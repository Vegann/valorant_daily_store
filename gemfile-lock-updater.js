module.exports.readVersion = function (contents) {
  const regex = /valorant_daily_store \((\d+\.\d+\.\d+)\)/g

  const result = contents.matchAll(regex)

  return [...result][0][1]
}

module.exports.writeVersion = function (contents, version) {
  const newContent = contents.replace(
    /valorant_daily_store \(\d+\.\d+\.\d+\)/,
    `VERSION = "${version}"`
  )

  return newContent
}
