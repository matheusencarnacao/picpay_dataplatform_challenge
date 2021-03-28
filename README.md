# Pic Pay - Data Platform Engineer Challenge

## Get Started

### Pré-requisitos
  - AWS CLI configurado e credenciado
  - terraform
  - python 3
  - pip

Para começar, primeiro execute o script `package_lambda.sh`

```
sh package_lambda.sh
```

Ele irá baixar todas as depedências necessárias para nossa Lambda function e empacotar dento de `punk_request.zip`



Execute o seguinte comando para verificar a infraestrutura planejada
```
terraform plan
```

Por fim execute o `apply` para aplicar as configurações
```
terraform apply
