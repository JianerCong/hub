CREATE TABLE cards(
  name varchar(20),
  id char(8),
  txt text
);

CREATE TABLE ms_cards(
  attr text,
  atk int,
  def int,
  level int
  ) INHERITS (cards);


CREATE TABLE spl_cards(
  -- spell cards
  type char(3)
) INHERITS (cards);


INSERT INTO ms_cards (name, id, txt,attr, atk, def, level)
VALUES ('ARMORD LIZARD', '15480588',
        'A lizard with a very tough hide and a vicious bite.',
        'Reptile', 1500, 1200, 4);

INSERT INTO ms_cards (name, id, txt,attr, atk, def, level)
VALUES ('D.D. SEEKER', '89015998' ,
        '(Quick Effect): You can target 1 face-up monster you control; banish it'
        'until the End Phase of the next turn. You can only use this effect of'
        '"D.D. Seeker" once per turn.',
        'Psychic',1500,800,4);

INSERT INTO spl_cards (name, id, txt, type)
VALUES ('LEGENDARY SWORD', '61584111',
        'Equip only to a Warrior monster. It gains 300 ATK/DEF.',
        'equ'
);

SELECT * FROM cards;

DROP TABLE ms_cards;
DROP TABLE spl_cards;
DROP TABLE cards;
