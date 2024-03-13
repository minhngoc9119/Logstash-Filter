> [!NOTE]
> config use for audit log format json from modsecurity.
# Config filter to receive json log:
```
filter {
    if [type] == "modsecurity" { 
        json {
            source => "message"
        }
    }
}
```
# DATA audit_data.messages:
```
# Warning. Pattern match "(?i)<script[^>]*>[\\s\\S]*?" at REQUEST_FILENAME. [file "/usr/share/modsecurity-crs/rules/REQUEST-941-APPLICATION-ATTACK-XSS.conf"] [line "82"] [id "941110"] [msg "XSS Filter - Category
 1: Script Tag Vector"] [data "Matched Data: <script> found within REQUEST_FILENAME: /<script>alert(1)</script>"] [severity "CRITICAL"] [ver "OWASP_CRS/3.3.2"] [tag "application-multi"] [tag "language-multi"]
[tag "platform-multi"] [tag "attack-xss"] [tag "paranoia-level/1"] [tag "OWASP_CRS"] [tag "capec/1000/152/242"], Access denied with code 403 (phase 2). Operator GE matched 5 at TX:anomaly_score. [file
"/usr/share/modsecurity-crs/rules/REQUEST-949-BLOCKING-EVALUATION.conf"] [line "93"] [id "949110"] [msg "Inbound Anomaly Score Exceeded (Total Score: 5)"] [severity "CRITICAL"] [ver "OWASP_CRS/3.3.2"] [tag
"application-multi"] [tag "language-multi"] [tag "platform-multi"] [tag "attack-generic"]
```
# EXAMPLE result:
1. audit_message.info:
```
audit_message.info:  [Warning. Pattern match "(?i)<script[^>]*>[\\s\\S]*?" at REQUEST_FILENAME. , Access denied with code 403 (phase 2). Operator GE matched 5 at TX:anomaly_score.]
```
2. audit_message.file:
```
audit_message.file: [/usr/share/modsecurity-crs/rules/REQUEST-941-APPLICATION-ATTACK-XSS.conf, /usr/share/modsecurity-crs/rules/REQUEST-949-BLOCKING-EVALUATION.conf]
```
3. audit_message.line:
```
audit_message.line: [82, 93]
```
4. audit_message.id:
```
audit_message.id: [941110, 949110]
```
5.audit_message.msg:
```
audit_message.msg: [XSS Filter - Category 1: Script Tag Vector, Inbound Anomaly Score Exceeded (Total Score: 5)]
```
6. audit_message.data:
```
audit_message.data: [Matched Data: <script> found within REQUEST_FILENAME: /<script>alert(1)</script>]
```
7. audit_message.severity:
```
audit_message.severity: [CRITICAL, CRITICAL]
```
8. audit_message.ver:
```
audit_message.ver: [OWASP_CRS/3.3.2]
```
9. audit_message.tag:
```
audit_message.tag:   [application-multi, language-multi, platform-multi, attack-xss, paranoia-level/1, OWASP_CRS, capec/1000/152/242, application-multi, language-multi, platform-multi, attack-generic]
```
