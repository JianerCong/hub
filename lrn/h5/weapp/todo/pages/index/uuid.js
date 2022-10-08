function v4() {
  function func() {
    return ( ( ( 1+Math.random() ) * 0x10000 ) | 0 ).toString( 16 ).substring( 1 );
  }
  // For calling it, stitch '3' in the 3rd group
  let UUID = (func() + func() + "-" + func() + "-" + func().substr(0,2) + "-" + func() + "-" + func() + func() + func()).toLowerCase();
  return UUID;
}

export {v4}
