// /**
//  * D3 layer for Leaflet
//  *
//  * Based on Leaflet.D3SvgOverlay
//  * - updated for use with D3 4.0 and NPM with ES6 modules
//  * - removed backwards compatibility with Leaflet 0.7 for readability and simplicity
//  *
//  * https://github.com/teralytics/Leaflet.D3SvgOverlay
//  * Copyright (c) 2014 Teralytics AG, MIT licensed:
//  * https://github.com/teralytics/Leaflet.D3SvgOverlay/blob/master/LICENSE
//  * Original author: Kirill Zhuravlev <kirill.zhuravlev@teralytics.ch>
//  *
//  */

import L from 'leaflet'
import * as d3 from 'd3'

// Tiny stylesheet bundled here instead of a separate file
d3.select('head')
  .append('style').attr('type', 'text/css')
  .text('g.d3-overlay *{pointer-events:visiblePainted}')

const D3Overlay = L.Layer.extend({
  includes: [],

  _undef: function (a) { return typeof a === 'undefined' },

  _options: function (options) {
    if (this._undef(options)) {
      return this.options
    }
    options.zoomHide = this._undef(options.zoomHide) ? false : options.zoomHide
    options.zoomDraw = this._undef(options.zoomDraw) ? true : options.zoomDraw

    this.options = options
  },

  _disableLeafletRounding: function () {
    this._leaflet_round = L.Point.prototype._round
    L.Point.prototype._round = function () { return this }
  },

  _enableLeafletRounding: function () {
    L.Point.prototype._round = this._leaflet_round
  },

  draw: function () {
    this._disableLeafletRounding()
    this._drawCallback(this.selection, this.projection, this.map.getZoom())
    this._enableLeafletRounding()
  },

  initialize: function (drawCallback, options) { // (Function(selection, projection)), (Object)options
    this._options(options || {})
    this._drawCallback = drawCallback
  },

  // Handler for 'viewreset'-like events, updates scale and shift after the animation
  _zoomChange: function (evt) {
    this._disableLeafletRounding()
    let newZoom = this._undef(evt.zoom) ? this.map._zoom : evt.zoom // 'viewreset' event in Leaflet has not zoom/center parameters like zoomanim
    this._zoomDiff = newZoom - this._zoom
    this._scale = Math.pow(2, this._zoomDiff)
    this.projection.scale = this._scale
    this._shift = this.map.latLngToLayerPoint(this._wgsOrigin)
      ._subtract(this._wgsInitialShift.multiplyBy(this._scale))

    let shift = ['translate(', this._shift.x, ',', this._shift.y, ') ']
    let scale = ['scale(', this._scale, ',', this._scale, ') ']
    this._rootGroup.attr('transform', shift.concat(scale).join(''))

    if (this.options.zoomDraw) { this.draw() }
    this._enableLeafletRounding()
  },

  onAdd: function (map) {
    this.map = map
    const _layer = this

    // SVG element
    this._svg = L.svg()
    map.addLayer(this._svg)
    this._rootGroup = d3.select(this._svg._rootGroup).classed('d3-overlay', true)

    this._rootGroup.classed('leaflet-zoom-hide', this.options.zoomHide)
    this.selection = this._rootGroup

    // Init shift/scale invariance helper values
    this._pixelOrigin = map.getPixelOrigin()
    this._wgsOrigin = L.latLng([0, 0])
    this._wgsInitialShift = this.map.latLngToLayerPoint(this._wgsOrigin)
    this._zoom = this.map.getZoom()
    this._shift = L.point(0, 0)
    this._scale = 1

    // Create projection object
    this.projection = {
      latLngToLayerPoint: function (latLng, zoom) {
        zoom = _layer._undef(zoom) ? _layer._zoom : zoom
        let projectedPoint = _layer.map.project(L.latLng(latLng), zoom)._round()
        return projectedPoint._subtract(_layer._pixelOrigin)
      },
      layerPointToLatLng: function (point, zoom) {
        zoom = _layer._undef(zoom) ? _layer._zoom : zoom
        let projectedPoint = L.point(point).add(_layer._pixelOrigin)
        return _layer.map.unproject(projectedPoint, zoom)
      },
      unitsPerMeter: 256 * Math.pow(2, _layer._zoom) / 40075017,
      map: _layer.map,
      layer: _layer,
      scale: 1
    }
    this.projection._projectPoint = function (x, y) {
      let point = _layer.projection.latLngToLayerPoint(new L.LatLng(y, x))
      this.stream.point(point.x, point.y)
    }
    this.projection.pathFromGeojson =
      d3.geoPath().projection(d3.geoTransform({point: this.projection._projectPoint}))

    this.projection.latLngToLayerFloatPoint = this.projection.latLngToLayerPoint
    this.projection.getZoom = this.map.getZoom.bind(this.map)
    this.projection.getBounds = this.map.getBounds.bind(this.map)
    this.selection = this._rootGroup

    // Initial draw
    this.draw()
  },

  getEvents: function () { return {zoomend: this._zoomChange} },

  onRemove: function (map) {
    this._svg.remove()
  },

  addTo: function (map) {
    map.addLayer(this)
    return this
  }

})

export default function (drawCallback, options) {
  return new D3Overlay(drawCallback, options)
}
