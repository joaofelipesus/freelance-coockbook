
// Toggle the disabled attribute of a text field based on the checked state of a checkbox field.
// @param checkboxField [Element] The checkbox field that controls the text field.
// @param textField [Element] The text field to toggle the disabled attribute.
const toggleRelatedCommentField = (checkboxField, textField) => {
  if (checkboxField.checked) {
    textField.removeAttribute('disabled')
  } else {
    textField.value = ''
    textField.setAttribute('disabled', 'disabled')
  }
}

export { toggleRelatedCommentField }
