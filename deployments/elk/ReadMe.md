# ELK

## Elasticsearch
In order to secure the Elasticsearch DB, we've enabled xpack security.  
This means, passwords are required for all connections.  
In order to properly set these secrets, go into the container and execute the following;  
```bash
# From inside the Elasticsearch container
$ /usr/share/elasticsearch/bin/elasticsearch-setup-passwords interactive
# Export from container
$ kcp ${elk-container}:/usr/share/elasticsearch/config/elasticsearch.keystore elasticsearch.keystore
# Create secret from it
$ k create secret generic elasticsearch --from-file elasticsearch.keystore
```

## Kibana
To get the credentials into the Kibana store;  
```bash
# From inside the Kibana container
$ /usr/share/kibana/bin/kibana-keystore create
$ /usr/share/kibana/bin/kibana-keystore add elasticsearch.password
# Export from container
$ kcp ${kibana-container}:/usr/share/kibana/config/kibana.keystore kibana.keystore
# Create secret from it
$ k create secret generic kibana --from-file kibana.keystore
```