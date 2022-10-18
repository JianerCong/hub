// a and b are javascript Date objects

// test it
/* const a = new Date("2017-01-01"),
 *       b = new Date("2017-07-25"),
 *       difference = dateDiffInDays(a, b); */
const _MS_PER_DAY = 1000 * 60 * 60 * 24;
function dateDiffInDays(a, b) {
  // Discard the time and time-zone information.
  const utc1 = Date.UTC(a.getFullYear(), a.getMonth(), a.getDate());
  const utc2 = Date.UTC(b.getFullYear(), b.getMonth(), b.getDate());

  return Math.floor((utc2 - utc1) / _MS_PER_DAY);

}

function makeTodo(name, done=false, ddl = undefined) {
  // The output of this function is used in 'pushTodo'
  // ddl is passed to new Date(ddl)
  let todo = {name, done};
  if (ddl) {
    todo.ddl = new Date(ddl);
    Object.defineProperties(todo,
                            {
                              "ddlString":
                              {
                                get() {
                                  return this.ddl.toISOString().substring(0, 10);
                                }
                              },
                              "dueInDays":
                              {
                                get() {
                                  return dateDiffInDays(new Date(), this.ddl);
                                }
                              },
                            }
                           );
  }

  // Define the todo to upload
  Object.defineProperties(todo,
                          {
                            "todoToUpload":
                            {
                              get() {
                                return {name: this.name, done: this.done, ddl: this.ddlString || ''};
                              }
                            }
                          }
                         );

  return todo;
}

export {makeTodo, _MS_PER_DAY}
