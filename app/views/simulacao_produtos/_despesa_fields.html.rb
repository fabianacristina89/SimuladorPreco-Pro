<fieldset>
<%= f.label :nome, "Nome" %>
<%= f.text_field :nome %>
<%= f.label :valor, "Nome" %>
<%= f.text_field :valor %>
<%= f.hidden_field :_destroy %>
 <%= link_to "remove", '#', class: "remove_fields" %>
</fieldset>