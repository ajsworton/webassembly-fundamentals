fetch('./checkers.wasm').then(response =>
response.arrayBuffer()
).then(bytes => WebAssembly.instantiate(bytes)).then(results => {
	console.log("Loaded wasm module");
	instance = results.instance;
console.log("instance", instance);

const white = 2;
const black = 1;
const crowned_white = 6;
const crowned_black = 5;

console.log("Calling offset");
const offset = instance.exports.offsetForPosition(3,4);
console.log("Offset for 3,4 is ",offset);

console.debug("White is white?", instance.exports.isWhite(white));
console.debug("Black is black?", instance.exports.isBlack(black));
console.debug("Black is white?", instance.exports.isWhite(black));
console.debug("Uncrowned white",
	instance.exports.isWhite(instance.exports.withoutCrown(crowned_white)));
console.debug("Uncrowned black",instance.exports.isBlack(instance.exports.withoutCrown(crowned_black)));
console.debug("Crowned is crowned",
	instance.exports.isCrowned(crowned_black));
console.debug("Crowned is crowned (b)",
	instance.exports.isCrowned(crowned_white));

console.debug("Typeof getTurnOwner: ",typeof instance.exports.getTurnOwner)

console.debug("Getting turn owner");
let turnOwner = instance.exports.getTurnOwner();

console.debug("TurnOwner is ",turnOwner);

instance.exports.setTurnOwner(1);
console.debug("TurnOwner is now 1",
	instance.exports.getTurnOwner() === 1);
instance.exports.toggleTurnOwner();
console.debug("TurnOwner is now 2",
	instance.exports.getTurnOwner() === 2);
instance.exports.toggleTurnOwner();
console.debug("TurnOwner is now 1",
	instance.exports.getTurnOwner() === 1);

});