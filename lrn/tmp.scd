"hi".postln;
{ [SinOsc.ar(440, 0, 0.2), SinOsc.ar(660, 0, 0.2)] }.play;

Quarks.install("https://github.com/supercollider/scel");
Quarks.folder.postln;

// -> /Users/<username>/Library/Application Support/SuperCollider/downloaded-quarks