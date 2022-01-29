module.exports.readVersion = function (contents) {
  const regex = /VERSION = "(\d+\.\d+\.\d+)"/g

  const result = contents.matchAll(regex)

  return [...result][0][1]
}

module.exports.writeVersion = function (contents, version) {
  const newContent = contents.replace(/VERSION = "(\d+\.\d+\.\d+)"/, version)

  return newContent
}
