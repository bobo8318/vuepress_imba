exports.isObject = obj => obj !== null && typeof obj === 'object'

const _toString = Object.prototype.toString

exports.getObjectType = x => _toString.call(x).slice(8, -1)

const isObjectType = type => x => getObjectType(x) === type
const isType = type => x => typeof x === type

exports.isString = isType('string')
exports.isFunction = isType('function')
exports.isBoolean = isType('boolean')
exports.isPlainObject = isObjectType('Object')
