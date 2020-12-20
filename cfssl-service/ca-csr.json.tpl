{
    "CN": ${cn},
    "key": {
        %{ for k,v in key_settings }
        ${k}: ${v},
        %{ endfor ~}
    },
    "names": [
        %{ for k,v in attrs }
        ${k}: ${v},
        %{ endfor ~}
    ]
}