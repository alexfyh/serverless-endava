## Requerimientos:
##  - aws cli


## Antes de ejecutar el siguiente script, es necesario autenticarse por alguno de los métodos:
##      a) Usando variables en entornos:
##          - Linux:
##              export AWS_ACCESS_KEY_ID=AKIAIOSFODNN7EXAMPLE
##              export AWS_SECRET_ACCESS_KEY=wJalrXUtnFEMI/K7MDENG/bPxRfiCYEXAMPLEKEY
##              export AWS_DEFAULT_REGION=us-west-2
##          - Windows:
##              setx AWS_ACCESS_KEY_ID AKIAIOSFODNN7EXAMPLE
##              setx AWS_SECRET_ACCESS_KEY wJalrXUtnFEMI/K7MDENG/bPxRfiCYEXAMPLEKEY
##              setx AWS_DEFAULT_REGION us-west-2
##
##      b) Ejecutando aws aconfigure



                                ######################################
                                #### CREACIÓN DE LA FUNCIÓN LAMBDA ###
                                ######################################

## Creación del rol
aws iam create-role --role-name helloWorld-aws_cli --assume-role-policy-document file://trust-policy.json

## Asignación de una policy básica al rol recientemente creado
aws iam attach-role-policy --role-name helloWorld-aws_cli --policy-arn arn:aws:iam::aws:policy/service-role/AWSLambdaBasicExecutionRole 

## Empaquetado del código a deployear
zip helloWorld.zip lambda_function.py

## Creación de la lambda (cambiar la variable ACCOUNT_ID por el valor )
aws lambda create-function --function-name helloWorld-aws_cli \
    --zip-file fileb://helloWorld.zip --handler lambda_function.lambda_handler --runtime python3.9 \
    --role arn:aws:iam::${ACCOUNT_ID}:role/helloWorld-aws_cli

## Para obtener el número de cuenta usando aws cli una vez seteado la autenticación:
aws sts get-caller-identity


                                ###############################################
                                #### ACTUALIZACIÓN DEL CÓDIGO DE LA LAMBDA ####
                                ###############################################
                                
zip helloWorld.zip lambda_function.py

aws lambda update-function-code --function-name helloWorld-aws_cli \
    --zip-file fileb://helloWorld.zip
