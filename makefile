EXTENSION   = bitmap_bucket
EXT_VERSION = 0.1

# sql
EXTENSION_SQL = sql/functions.sql
EXT_SQL     = sql/$(EXTENSION)--$(EXT_VERSION).sql

DATA_built  = $(EXT_SQL)

PG_CONFIG   = /usr/local/gpdb/bin/pg_config
PGXS := $(shell $(PG_CONFIG) --pgxs)

include $(PGXS)

sql/$(EXTENSION)--$(EXT_VERSION).sql: $(EXTENSION_SQL)
	cat $^ > $@
