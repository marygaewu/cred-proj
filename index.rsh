'reach 0.1';

export const main = Reach.App(() => {
  setOptions({ untrustworthyMaps: true });
  const Admin = Participant('Admin', {
    meta: Bytes(256),
    upload: Bytes(256),
  });
  const Organization = ParticipantClass('Organization', {
    request: Fun([], Bool),
    notify: Fun([Address, Bool], Null),
  });
  const Student = ParticipantClass('Student', {
    approve: Fun([Address], Bool),
    view: Fun([], Bool),
    notify: Fun([Address, Bool], Null),
  });
  init();

  Admin.only(() => {
    const meta = declassify(interact.meta);
    const upload = declassify(interact.upload);
  });
  Admin.publish(meta, upload);
  // XXX expose meta as a view

  const holdersM = new Set();
  // XXX expose holdersM.member as a view

  var [] = [];
  invariant( balance() == 0 );
  while ( true ) {
    commit();

    // XXX Right now, the students and admin interact in a synchronized manner.
    // Instead, students could be free to add themselves to the "wantM" set (if
    // they aren't in holdersM) and the admin can come in later and move things
    // from "wantM" to "holdersM"

    Organization.only(() => {
      const want = declassify(interact.request());
      assume(! holdersM.member(this));
    });
    Organization.publish().when(want).timeout(false);
    const requester = this;
    require(! holdersM.member(requester));
    commit();

    Student.only(() => {
      const okay = declassify(interact.approve(requester));
    });
    Student.publish(okay);
    if ( okay ) {
      holdersM.insert(requester);
    }
    Student.interact.notify(requester, okay);
    continue;

  }
  commit();

  exit();
});

