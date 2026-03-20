CREATE EXTENSION IF NOT EXISTS "uuid-ossp";

-- 2. Modify the column: Drop the int default, change type, and generate new UUIDs
ALTER TABLE tasks 
    ALTER COLUMN id DROP DEFAULT,
    ALTER COLUMN id TYPE UUID USING (uuid_generate_v4()),
    ALTER COLUMN id SET DEFAULT uuid_generate_v4();