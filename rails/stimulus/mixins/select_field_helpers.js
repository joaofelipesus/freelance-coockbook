
// Remove all options from a select field and add new options including an empty option.
// @param selectField [Element] The select field to change options.
// @param newOptions [Array<String>] The new options to add to the select field.
const changeSelectOptions = (selectField, newOptions) => {
  // Remove all existing options
  while (selectField.firstChild) {
    selectField.removeChild(selectField.firstChild);
  }

  // Add empty option
  newOptions.unshift('')

  // Add new options
  newOptions.forEach(optionText => {
    let newOption = document.createElement('option');
    newOption.text = optionText;
    selectField.add(newOption);
  });
}

export { changeSelectOptions }
