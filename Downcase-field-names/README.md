##SOURCE: [https://gist.github.com/yaauie](https://gist.github.com/yaauie/6c4f14a84408ed2473e5a0a92a60993e) <br>
##HOW TO USE:
- Create file downcase-filter.ruby.
- Create file config in logstash use filter ruby, example:
```
filter {
    if [type] == "modsecurity" in [tags] { 
        ruby {
          path => "/etc/logstash/downcase-filter.ruby"
        }
    } 
}
```
-  After that restart logstash service:
```
sudo service logstash restart
```
-  
