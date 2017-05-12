import L from 'leaflet'

const Counter = L.Control.extend({
  onAdd: function (map) {
    this._el = L.DomUtil.create('span', 'counter')
    return this._el
  },

  update: function (count) {
    this._el.textContent = count
  }
})

export default (...args) => {
  return new Counter(...args)
}
