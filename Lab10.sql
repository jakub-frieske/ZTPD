-- 1
create table cytaty_kopia as select * from ZSBD_TOOLS.CYTATY;

-- 2
select * 
from cytaty_kopia
where lower(tekst) like '%optymista%' and lower(tekst) like '%pesymista%';


-- 3
create index tekst_idx on cytaty_kopia(tekst)
indextype is CTXSYS.CONTEXT;

-- 4
select * 
from cytaty_kopia
where CONTAINS(tekst, 'optymista and pesymista')>0;

-- 5
select * 
from cytaty_kopia
where CONTAINS(tekst, 'pesymista not optymista')>0;

-- 6
select * 
from cytaty_kopia
where CONTAINS(tekst, 'near((pesymista, optymista), 3)')>0;

-- 7
select * 
from cytaty_kopia
where CONTAINS(tekst, 'near((pesymista, optymista), 10)')>0;

-- 8
select * 
from cytaty_kopia
where CONTAINS(tekst, 'życi%',1)>0;

-- 9
select score(1), id, autor, tekst
from cytaty_kopia
where CONTAINS(tekst, 'życi%', 1)>0;

-- 10
select score(1), id, autor, tekst
from cytaty_kopia
where CONTAINS(tekst, 'życi%', 1)>0
order by score(1) desc
fetch first 1 rows only;


-- 11
select *
from cytaty_kopia
where CONTAINS(tekst, '!problm', 1)>0;

-- 12
insert into cytaty_kopia values(
39,
'Bertrand Russell', 
'To smutne, że głupcy są tacy pewni siebie, a ludzie rozsądni tacy pełni wątpliwośc');

-- 13 problem z indeksem
select *
from cytaty_kopia
where CONTAINS(tekst, 'głupcy', 1)>0;

-- 14
select *
from DR$tekst_idx$I
where token_text like 'GŁUPCY';

--15 
drop index tekst_idx;
create index tekst_idx on cytaty_kopia(tekst)
indextype is CTXSYS.CONTEXT;

-- 16
select *
from cytaty_kopia
where CONTAINS(tekst, 'głupcy', 1)>0;

--17
drop index tekst_idx;
drop table cytaty_kopia;

-- 1
create table quotes_copy as select * from ZSBD_TOOLS.QUOTES;

-- 2
create index text_idx on quotes_copy(text)
indextype is CTXSYS.CONTEXT;

-- 3
select *
from quotes_copy
where CONTAINS(text, 'work', 1)>0;
select *
from quotes_copy
where CONTAINS(text, '$work', 1)>0;
select *
from quotes_copy
where CONTAINS(text, 'working', 1)>0;
select *
from quotes_copy
where CONTAINS(text, '$working', 1)>0;

-- 4 
select *
from quotes_copy
where CONTAINS(text, 'it', 1)>0;

-- 5 
select * from CTX_STOPLISTS;

-- 6
select * from CTX_STOPWORDS;

-- 7
drop index text_idx;
create index text_idx on quotes_copy(text)
indextype is CTXSYS.CONTEXT
parameters ('stoplist CTXSYS.EMPTY_STOPLIST');

--8
select *
from quotes_copy
where CONTAINS(text, 'it', 1)>0;

--9
select *
from quotes_copy
where CONTAINS(text, 'fool and humans', 1)>0;

--10
select *
from quotes_copy
where CONTAINS(text, 'fool and computer', 1)>0;

--11
select *
from quotes_copy
where CONTAINS(text, '(fool and humans) within sentence', 1)>0;

--12
drop index text_idx;

--13
begin
 ctx_ddl.create_section_group('nullgroup', 'NULL_SECTION_GROUP');
 ctx_ddl.add_special_section('nullgroup', 'SENTENCE');
 ctx_ddl.add_special_section('nullgroup', 'PARAGRAPH');
end; 

-- 14
create index text_idx on quotes_copy(text)
indextype is CTXSYS.CONTEXT
parameters ('stoplist CTXSYS.EMPTY_STOPLIST
            section group nullgroup');
            
-- 15
select *
from quotes_copy
where CONTAINS(text, '(fool and humans) within sentence', 1)>0;

select *
from quotes_copy
where CONTAINS(text, '(fool and computer) within sentence', 1)>0;

-- 16
select *
from quotes_copy
where CONTAINS(text, 'humans', 1)>0;

--17
drop index text_idx;
begin
 ctx_ddl.create_preference('lex_z_m','BASIC_LEXER');
 ctx_ddl.set_attribute('lex_z_m',
 'printjoins', '-');
 ctx_ddl.set_attribute ('lex_z_m',
 'index_text', 'YES');
end;
create index text_idx on quotes_copy(text)
indextype is CTXSYS.CONTEXT
parameters ('stoplist CTXSYS.EMPTY_STOPLIST
            section group nullgroup
            LEXER lex_z_m');
            
-- 18
select *
from quotes_copy
where CONTAINS(text, 'humans', 1)>0;

-- 19
select *
from quotes_copy
where CONTAINS(text, 'non\-humans', 1)>0;

-- 20 
drop index text_idx;
drop table quotes_copy;