# Common to all locations in cluster
av_zone                         = ["1","2"]
cluster-base-domain             = "kaiser.guru"
username                        = "demo@redislabs.com"
password                        = "EVENmoarSECURE"
re-download-url                 = "https://s3.amazonaws.com/redis-enterprise-software-downloads/5.4.10/redislabs-5.4.10-22-rhel7-x86_64.tar"
demodb-name                     = "first-db"
cluster-base-resource-group     = "azuse-kaiserguru-dns-rg-prod"
re-license                      = <<EOF
                                    ----- LICENSE START -----
                                    Q4KVocZjD3/FBc3Q8s8xMt6+aRmPsLyp4VV4uC6fNFvxLjc4bhaPJOVK8AeU
                                    V1G7QZJu0byxnDYMLbRQs3q3ptq9+IYiUrQxuhwfh8q/mhscbsEokNNMJKrH
                                    QBdr5w4YyzOJnT71OZ7wizxkCv0DO3FBQzONd+F3w84+Kg9yABrdTYVTzrXn
                                    VpDa5tCfJJ1Bf98hIqVeOAJTCdofvbYAh86H1TKN4wqi0y7NHs7xrwdYXeWf
                                    Ybp2EHmpQ1kDPsc10uODcOWQweLXd+Mw00FhWOQVpzKbBjh1sfz5eyYMjCll
                                    MtV60Z4ecimA/i6Asclfj+56UP5dWMJ+HsU1VQZ/tw==
                                    ----- LICENSE END -----
                                EOF

# Tags
cost_center                     = "57601"
business_unit                   = "4116"
owner                           = "mkaiser@incomm.com"
environment                     = "POC"
platform_application            = "Serve"
compliance_data_profile         = "NON-PCI"
data_sovereignty_location       = "US"