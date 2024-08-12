# Data export

The module `DataExport` is responsible for generate a Excel file with all data from the application, as this is a common task this module was created to be generic and extensible to be used in any application.

## How to use

Once copied the full module from `TODO` and pasted on `lib` directory, run the task that generates a YML file with all models, attributes and the default handlers. If there are any attribute that must be handled with a custom logic, implement the method on `lib/data_export/handlers/custom_handlers.rb` and change the attribute handler to the custom handler.

```bash
# Generate schema
rails data_export:generate_schema
# Export data
rails data_export:export_data
```

### Copy module

Copy and paste the files from the following list to the application:
  - `lib/data_export`;
  - `test/lib/data_export`;
  - `lib/tasks/data_export.rake`.

### Attach file to user

Add the method `has_one_attached` to the user model.

```ruby
class User < ApplicationRecord
  has_one_attached :export_data
end
```

### Download link

Add the link to download the excel file in the view, **validate if current_user is a manager**.

```erb
<li>
  <% if current_user.export_data.attached? %>
    <%= link_to 'Exportar dados',
      current_user.export_data,
      class: 'text-left text-lg text-white font-bold'
    %>
  <% end %>
</li>
```

### Config cron task to ru task every 12 hours

Use heroku scheduler to run the task every 12 hours.

```bash
rails data_export:export_data
```
