#!/usr/bin/env python3
import sys
import sqlite3


def parse_file(file_path):
    with open(file_path) as file:
        current_block = {}
        for line in file:
            if line.strip() == '':  # New block on empty line
                if current_block:
                    yield current_block
                    current_block = {}
            else:
                key, value = line.strip().split(': ', 1)
                current_block[key.lower()] = value
        if current_block:  # Add the last block if any
            yield current_block


def insert(conn, blocks):
    keys = None
    crs = conn.cursor()
    blocks = list(blocks)

    keys = set().union(*(set(block.keys()) for block in blocks))

    crs.execute('DROP TABLE IF EXISTS packages')
    column_definitions = ', '.join([f'{key} TEXT NULL' for key in keys])
    crs.execute(f'CREATE TABLE packages ({column_definitions})')

    for block in blocks:

        assert set(block.keys()) < set(keys), (set(keys), set(block.keys()))

        columns = ', '.join(block.keys())
        values = ', '.join('?' for value in block.values())
        insert_sql = f'INSERT INTO packages ({columns}) VALUES ({values})'
        crs.execute(insert_sql, tuple(block.values()))

    crs.close()
    conn.commit()


def main():
	#path to Packages file as first arg
    [arg0, file_path] = sys.argv

#    db_name = 'packages.db'
	# Remove leading PATH and trailing '/Packages' from the file path
    db_name = file_path.lstrip('/var/cache/edb/binhost/').rstrip('/Packages').replace('/', '_') + '.db'
    # Replace any slashes with underscores
	#Example: 10.1.1.1_binhost9.db

    with sqlite3.connect(db_name) as conn:
        insert(conn, parse_file(file_path))

#    print(f'{db_name} generated successfully.')
    print(f'{db_name}')


if __name__ == "__main__":
    main()
