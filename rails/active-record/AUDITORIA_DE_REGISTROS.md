# Versionamento de models com paper-trail

A gem [paper_trail](https://github.com/paper-trail-gem/paper_trail) mantém o versionamento de mudanças e models Rails, é aplicada em sistemas que necessitam auditoria dos registros. É importante considerar o crescimento do banco de dados em aplicações que utilizam `paper_trail`.

### Setup

Após a instalação da gem for finalizada deve-se executar uma `rake task` que irá gerar uma tabela chamada `versions`, que será o local em que os registros serão salvos.

Para que seja possível carregar versões anteriores de um modelo através da chamada do método `patient.paper_trail.pervious_version` é necessário adicionar a seguinte config em `config/application.rb`, para que seja permitido carregar as classes do objeto `serializado` em `YML`.

```Ruby
# PaperTrail configuration to permit load ActiveRecord objects from stored YML files.
config.active_record.yaml_column_permitted_classes = %w[Symbol Date Time BigDecimal]
```


### Uso

Para que um model tenha as versões salvas na tabela `versions` deve conter o helper `has_paper_trail`, com isso sempre que algum registro sofrer alteração será criado um novo registro em `versions`. Os objetos desta classe passam a possuir os seguintes métodos utilizados para manipular versões dos objetos:
  - `.versions` -> retorna uma lista com todos os registros salvos em `versions` vinculados ao objeto;
  - `.paper_trail.previous_version` -> carrega a versão anterior do objeto. É possível dar um erro referente ao carregamento do objeto a partir de um YML, que caso ocorra a solução é listar a classe que causou o erro em `config/application.rb -> config.active_record.yaml_column_permitted_classes = [...]`
