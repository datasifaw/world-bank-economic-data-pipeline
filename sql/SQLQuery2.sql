
SELECT
    local_net_address,
    local_tcp_port,
    net_transport,
    auth_scheme
FROM sys.dm_exec_connections
WHERE session_id = @@SPID;
