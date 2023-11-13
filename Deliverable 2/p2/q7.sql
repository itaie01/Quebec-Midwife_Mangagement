alter table tests add check (labWorkDate >= prescribedDate)
;

insert into tests (testID, ttype, prescribedDate, sampleDate, labWorkDate, result) VALUES
(1000, 'bood type', '2022-01-02', '2022-01-02', '2022-01-01', 'A+')
;