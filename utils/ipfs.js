const { create } = require('ipfs-http-client');
const { sha256 } = require('js-sha256');

const ipfs = create({
  host: 'localhost',
  port: 5001,
  protocol: 'http'
});

const uploadToIPFS = async (data) => {
  const { cid } = await ipfs.add(JSON.stringify(data));
  return {
    cid: cid.toString(),
    hash: '0x' + sha256(JSON.stringify(data))
  };
};

const fetchFromIPFS = async (cid) => {
  const chunks = [];
  for await (const chunk of ipfs.cat(cid)) {
    chunks.push(chunk);
  }
  return JSON.parse(Buffer.concat(chunks).toString());
};

module.exports = { uploadToIPFS, fetchFromIPFS };