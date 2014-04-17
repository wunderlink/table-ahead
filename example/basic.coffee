
require('cssify').byUrl('//netdna.bootstrapcdn.com/bootstrap/3.1.1/css/bootstrap.min.css')


donuts = [
  type: 'Old Fashioned'
  topping: 'Chocolate Sprinkles'
  filling: 'None'
,
  type: 'Traditional'
  topping: 'Glaze'
  filling: 'None'
,
  type: 'Traditional'
  topping: 'Chocolate Glaze'
  filling: 'Chocolate Pudding'
,
  type: 'Traditional'
  topping: 'Rainbow Sprinkles'
  filling: 'Unicorns'
,
  type: 'Old Fashioned'
  topping: 'Maple Bacon'
  filling: 'Chocolate'
]

columns = [
  property: 'type'
,
  property: 'topping'
,
  property: 'filling'
]

ta = require '../index.js'
tahead = new ta columns


table = document.createElement 'table'
table.width = 500
table.style.padding = 5
table.style.border = '1px solid'

tr = document.createElement 'tr'
for handle, value of donuts[0]
  th = document.createElement 'th'
  th.innerHTML = handle
  tr.appendChild th
table.appendChild tr

for row in donuts
  tr = document.createElement 'tr'
  for handle, value of row
    console.log value
    td = document.createElement 'td'
    td.innerHTML = value
    tr.appendChild td
  tahead.add row, tr
  table.appendChild tr

document.body.innerHTML = 'Table-Ahead'

for handle, value of donuts[0]
  div = document.createElement 'div'
  div.innerHTML = handle
  div.appendChild tahead.controls[handle]
  document.body.appendChild div

div = document.createElement 'div'
div.innerHTML = 'Search All'
div.appendChild tahead.controls['search_all']
document.body.appendChild div

document.body.appendChild table
document.body.style.margin = '20px'



