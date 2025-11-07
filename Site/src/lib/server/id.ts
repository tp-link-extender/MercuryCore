// Very legacy ID generation gone!

const min = 100_000_000
const max = 1_000_000_000 // exclusive
export const randomAssetId = () => Math.floor(Math.random() * (max - min) + min)
