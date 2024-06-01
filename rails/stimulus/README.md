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

## Estrutura de uma controller

Controllers `stimulus` são compostos por `targets` que são os elementos HTML que serão manipulados,
e `actions` que são os métodos que serão executados quando um evento específico ocorrer. As actions
devem ser o mais simples possível, mudando a cor de um texto ou exibindo novos elementos na tela.

Normalmente controller `stimulus` são responsáveis por manipular apenas uma parte da tela, ou seja,
um formulário, um modal, um menu, etc. Por isso a controller é vinculada a uma tag HTML específica
e tem acesso apenas aos elementos filhos dessa tag. O vínculo é feito através do attributo
`data-controller` que recebe como argumento o nome da controller.

```html
<div data-controller="patients-form">
  <form>...</form>
</div>
```

`Targets` são declaradas no início da controller na forma de uma lista que contém o nome dos elementos
que serão mapeados na view `HTML (erb)`, através de `data-atributes`. O `stimulus` se baseia no
conceito de `convention over configuration`, ou seja, os padrões da biblioteca **devem ser seguidos**
caso contrário o código não irá funcionar. Ao fazer referência a um elemento na controller, o nome
do elemento deve ser precedido por `this.` e termina em `Target`.

```javascript
// refer to a element declared on targets as name
this.nameTarget
```

`Actions` são métodos que são executados quando um evento específico ocorre. Por exemplo, ao clicar
em um botão, ao mudar o valor de um campo de texto, ao selecionar uma opção de um campo select, etc.
Uma action pode ser chamada no momento em que a página é carregada, caso seja necessário exibir ou
ocultar elementos da tela, para isso é utilizado o método `connect`.

```javascript
import { Controller } from "@hotwired/stimulus"

// Connects to data-controller="adverse-event-form"
export default class extends Controller {
  static targets = [
    'adverseEventKindOtherOption', 'adverseEventKindOtherField'
  ]

  // NOTE: code executed when the controller is connected to the DOM.
  connect() {
    this.handleOtherAdverseEventKindChange()
  }

  // Method that disable the adverseEventKindOtherField when the adverseEventKindOtherOption
  // is unchecked.
  handleOtherAdverseEventKindChange () {
    if (this.adverseEventKindOtherOptionTarget.checked) {
      this.adverseEventKindOtherFieldTarget.removeAttribute('disabled')
    } else {
      this.adverseEventKindOtherFieldTarget.setAttribute('disabled', 'disabled')
      this.adverseEventKindOtherFieldTarget.value = ''
    }
  }
}
```
```html
<div data-controller="adverse-event-form">
  <input
    type="checkbox"
    data-patients-form-target="adverse-event-kind-other-option"
    data-action="change->adverse-event-form#handleOtherAdverseEventKindChange"
  >
  <input
    type="text"
    data-patients-form-target="adverse-event-kind-other-field"
    disabled
  >
</div>
```
