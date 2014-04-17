
require('./style.css')
Fuse = require('../vendor/fuse.min.js')


module.exports = (columns) ->
  return new TableAhead columns

class TableAhead
  id: ''
  table: ''
  tdata: []
  cols: []
  fuses: {}
  controls: {}
  controlHolder: ''
  constructor: (columns) ->
    @.add = @.add.bind(@)
    @columns = columns

    search_all =
      property: 'search_all'
      title: 'Search All'

    @columns = columns
    for col in columns
      @controls[col.property] = @buildControl(col)
    @controls['search_all'] = @buildControl(search_all)

  formatData: (row, col) ->
    value = row[col.property]
    if col.template?
      value = col.template( value, row )
    if value?
      tmp = document.createElement('div')
      tmp.innerHTML = value
      value = tmp.textContent
    return value

  buildFuse: (handle) ->
    if handle is 'search_all'
      keys = []
      for col in @columns
        keys.push col.property
    else
      keys = [handle]
    options =
      threshold: 0.1
      keys: keys
    fuse = new Fuse(@tdata, options)
    return fuse

  buildControl: (col) ->
    _this = @
    s = document.createElement('input')
    s.type = 'text'
    s.setAttribute('data-handle', col.property)
    s.onkeyup = (e) ->
      handle = this.getAttribute('data-handle')
      if !_this.fuses[handle]?
        _this.fuses[handle] = _this.buildFuse( handle )
      if this.value is ''
        _this.toggleRows( 'all' )
      else
        matches = _this.fuses[handle].search( this.value )
        _this.toggleRows( matches )

    return s

  toggleRows: (show) ->
    if show is 'all'
      for row in @tdata
        row._tr.style.display = 'table-row'
    else
      for row in @tdata
        row._tr.style.display = 'none'
      for row in show
        row._tr.style.display = 'table-row'

  add: (obj, tr) ->
    #r = @formatDataRow obj
    n = {}
    for col in @columns
      n[col.property] = @formatData obj, col
    n._tr = tr
    @tdata.push n
