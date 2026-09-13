function query-users
    duckdb -c "
        FROM read_csv('/etc/passwd',
          delim = ':',
          header = false,
          quote = '',
          columns = {
            'username':'VARCHAR',
            'passwd':'VARCHAR',
            'uid':'INTEGER',
            'gid':'INTEGER',
            'info':'VARCHAR',
            'home':'VARCHAR',
            'shell':'VARCHAR'
          })
        "
end
