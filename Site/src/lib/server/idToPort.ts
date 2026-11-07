export const proxyOffset = 25000

const idToPort = (id: number) => 10000 + (id % proxyOffset)

export default idToPort
