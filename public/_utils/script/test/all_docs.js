// Licensed under the Apache License, Version 2.0 (the "License"); you may not
// use this file except in compliance with the License. You may obtain a copy of
// the License at
//
//   http://www.apache.org/licenses/LICENSE-2.0
//
// Unless required by applicable law or agreed to in writing, software
// distributed under the License is distributed on an "AS IS" BASIS, WITHOUT
// WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied. See the
// License for the specific language governing permissions and limitations under
// the License.

couchTests.all_docs = function(debug) {
  var db = new CouchDB("test_suite_db", {"X-Couch-Full-Commit":"false"});
  db.deleteDb();
  db.createDb();
  if (debug) debugger;

  // Create some more documents.
  // Notice the use of the ok member on the return result.
  T(db.save({_id:"0",a:1,b:1}).ok);
  T(db.save({_id:"3",a:4,b:16}).ok);
  T(db.save({_id:"1",a:2,b:4}).ok);
  T(db.save({_id:"2",a:3,b:9}).ok);

  // Check the all docs
  var results = db.allDocs();
  var rows = results.rows;

  T(results.total_rows == results.rows.length);

  for(var i=0; i < rows.length; i++) {
    T(rows[i].id >= "0" && rows[i].id <= "4");
  }

  // Check _all_docs with descending=true
  var desc = db.allDocs({descending:true});
  T(desc.total_rows == desc.rows.length);

  // Cliclac : This cannot work wih Mongo...
  // Check _all_docs offset
  // var all = db.allDocs({startkey:"2"});
  // T(all.offset == 2);

  // Cliclac : does not work with mongo and seems that it will be deprecated in CouchDB... so...
  // check that the docs show up in the seq view in the order they were created
  // var all_seq = db.allDocsBySeq();
  // var ids = ["0","3","1","2"];
  // for (var i=0; i < all_seq.rows.length; i++) {
  //   var row = all_seq.rows[i];
  //   T(row.id == ids[i]);
  // };

  // it should work in reverse as well
  // all_seq = db.allDocsBySeq({descending:true});
  // ids = ["2","1","3","0"];
  // for (var i=0; i < all_seq.rows.length; i++) {
  //   var row = all_seq.rows[i];
  //   T(row.id == ids[i]);
  // };

  // check that deletions also show up right
  // var doc1 = db.open("1");
  // var deleted = db.deleteDoc(doc1);
  // T(deleted.ok);
  // all_seq = db.allDocsBySeq();
  // 
  // // the deletion should make doc id 1 have the last seq num
  // T(all_seq.rows.length == 4);
  // T(all_seq.rows[3].id == "1");
  // T(all_seq.rows[3].value.deleted);

  // is this a bug?
  // T(all_seq.rows.length == all_seq.total_rows);

  // // do an update
  // var doc2 = db.open("3");
  // doc2.updated = "totally";
  // db.save(doc2);
  // all_seq = db.allDocsBySeq();
  // 
  // // the update should make doc id 3 have the last seq num
  // T(all_seq.rows.length == 4);
  // T(all_seq.rows[3].id == "3");

  // ok now lets see what happens with include docs
  // all_seq = db.allDocsBySeq({include_docs: true});
  // T(all_seq.rows.length == 4);
  // T(all_seq.rows[3].id == "3");
  // T(all_seq.rows[3].doc.updated == "totally");
  // 
  // // and on the deleted one, no doc
  // T(all_seq.rows[2].value.deleted);
  // T(!all_seq.rows[2].doc);

  // test the all docs collates sanely
  db.save({_id: "Z", foo: "Z"});
  db.save({_id: "a", foo: "a"});

  var rows = db.allDocs({startkey: "Z", endkey: "Z"}).rows;
  T(rows.length == 1);
};
