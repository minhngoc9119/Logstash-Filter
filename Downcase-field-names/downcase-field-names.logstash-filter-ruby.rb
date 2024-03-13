###############################################################################
# downcase-field-names.logstash-filter-ruby.rb
# ---------------------------------
# A script for a Logstash Ruby Filter to transform field names to all lowercase
###############################################################################
#
# Copyright 2020 Ry Biesemeyer
#
# Permission is hereby granted, free of charge, to any person obtaining a copy
# of this software and associated documentation files (the "Software"), to deal
# in the Software without restriction, including without limitation the rights
# to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
# copies of the Software, and to permit persons to whom the Software is
# furnished to do so, subject to the following conditions:
#
# The above copyright notice and this permission notice shall be included in
# all copies or substantial portions of the Software.
#
# THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
# IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
# FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
# AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
# LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
# OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE
# SOFTWARE.
def register(params)
  params = params.dup

  # source: if provided, only the provided field reference (and potentially its children)
  #         will be transformed (default: entire event)
  @source = params.delete('source')

  # recursive: set to `false` to avoid recusrive walking of deeply-nested hashes and arrays
  #            (default: true)
  @recursive = params.delete('recursive')
  @recursive = case @recursive && @recursive.downcase
               when nil, true,  'true'  then true
               when      false, 'false' then false
               else report_configuration_error("script parameter `recursive` must be either `true` or `false`; got `#{@recursive}`.")
               end

  params.empty? || report_configuration_error("unknown script parameter(s): #{params.keys}.")
end

def report_configuration_error(message)
  raise LogStash::ConfigurationError, message
end

def filter(event)
  _transform_keys(event, [@source].compact, &:downcase)
rescue => e
  log_meta = {exception: e.message}
  log_meta.update(:backtrace, e.backtrace) if logger.debug?
  logger.error('failed to downcase field names', log_meta)
  event.tag('_downcasefieldnameserror')
ensure
  return [event]
end

##
# runs the given transformer block on each field reference fragment
def _transform_keys(event, keypath=[], &transformer)
  if keypath.empty?
    node = event.to_hash
  else
    current_field_reference = _build_canonical_field_reference(keypath)
    return unless event.include?(current_field_reference)

    transformed_keypath = keypath.map(&transformer)
    if transformed_keypath != keypath
      target_field_reference = _build_canonical_field_reference(transformed_keypath)
      event.set(target_field_reference, event.remove(current_field_reference))
      keypath = transformed_keypath
      current_field_reference = target_field_reference
    end
    node = event.get(current_field_reference)
  end

  if @recursive || keypath.empty?
    if node.kind_of?(Array)
      node.size.times do |idx|
        _transform_keys(event, keypath + [idx.to_s], &transformer)
      end
    elsif node.kind_of?(Hash)
      node.keys.each do |subkey|
        _transform_keys(event, keypath + [subkey], &transformer)
      end
    end
  end
end

##
# builds a valid field reference from the provided components
def _build_canonical_field_reference(fragments)
  return "[#{fragments.join('][')}]"
end
