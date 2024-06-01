# Stimulus controllers

O uso de controllers `stimulus` é feito quando views ou formulários possuem alguma interação que não
necessita de uma requisição ao servidor. Por exemplo, em um formulário em que ao selecionar uma opção
específica de um campo do tipo select sejam exibidas as próximas perguntas relacionadas a essa opção.

Até o momento **não utilizamos** controllers `stimulus` para interações que necessitam de requisições
ao backend, como por exemplo, salvar um registro no banco de dados ou buscar uma lista de regi_stros.
Neste tipo de cenário é indicado o uso de `turbo frames`.

## Setup

Para que seja possível utilizar controllers `stimulus` é necessário instalar a `gem 'stimulus-rails'`
e executar o comando `rails stimulus:install`. Com o `stimulus` instalado é possível criar controllers
utilizando o comando `rails generate stimulus controller_name`.

```bash
bundle exec rails g stimulus patients_form
```
