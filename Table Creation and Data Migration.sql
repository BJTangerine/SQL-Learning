-- create table w/ text data-type columns and primary key column
CREATE TABLE professors (
    firstname text,
    lastname text,
    university_shortname text
)
;


-- enforce data consistency using attribute constraints to disallow NULLs 
ALTER TABLE professors
    ALTER COLUMN firstname SET NOT NULL,
    ALTER COLUMN lastname SET NOT NULL
;


-- migrating data from old table to newly created professors table.
INSERT INTO professors (
    SELECT DISTINCT
        firstname,
        lastname,
        university_shortname
    FROM university_professors
)
;


-- delete old table.
DROP TABLE university_professors
;


-- add primary key column
ALTER TABLE professors
    ADD COLUMN id serial,
    ADD CONSTRAINT professors_pkey PRIMARY KEY (id),

    -- adds foreign key on professors table referencing another universities table
    ADD CONSTRAINT professors_fkey FOREIGN KEY (university_shortname) REFERENCES universities (id)
;
