
require('./style.css')
Fuse = require('../vendor/fuse.min.js')



class TableAhead
  constructor: (columns, opts={}) ->
    @.add = @.add.bind(@)
    @columns = columns

    search_all =
      property: 'search_all'
      title: 'Search All'

    @fuzzyMatch = true
    if opts.fuzzyMatch
      @fuzzyMatch = opts.fuzzyMatch
    @columns = columns
    @tdata = []
    @fuses = {}
    @controls = {}
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
      threshold: 0.3
      keys: keys
    fuse = new Fuse(@tdata, options)
    return fuse

  buildControl: (col) ->
    _this = @
    s = document.createElement('input')
    s.type = 'text'
    s.setAttribute('data-handle', col.property)
    s.onkeyup = (e) ->
      _this.narrowRows()
    return s

  narrowRows: ->
    empty = true
    matches = []
    for handle, val of @controls
      if val.value isnt ''
        empty = false
        matched = @checkColumn handle, val
        matches = @mergeMatches matches, matched
    if empty
      @toggleRows( 'all' )
    else
      @toggleRows( matches )

  checkColumn: (handle, item) ->
    if @fuzzyMatch
      matches = @tdata.filter (row) ->
        prop = row[handle]
        val = item.value
        match = typeof prop == 'string' && prop.toLowerCase().indexOf(val.toLowerCase()) > -1
        if match
          return row
      return matches
    else
      if !@fuses[handle]?
        @fuses[handle] = @buildFuse( handle )
      if item.value isnt ''
        matches = @fuses[handle].search( item.value )
        return matches
    return []

  mergeMatches: (matched, newMatches) ->
    intersect = []
    if matched.length < 1
      return newMatches
    for match in matched
      for newMatch in newMatches
        if match is newMatch
          intersect.push newMatch
    return intersect


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
    n = {}
    for col in @columns
      n[col.property] = @formatData obj, col
    n._tr = tr
    @tdata.push n


module.exports = TableAhead
