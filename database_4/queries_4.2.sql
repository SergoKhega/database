WITH RECURSIVE Subordinates AS (
    SELECT 
        EmployeeID,
        Name,
        ManagerID,
        DepartmentID,
        RoleID
    FROM 
        Employees
    WHERE 
        ManagerID = 1

    UNION ALL

    SELECT 
        e.EmployeeID,
        e.Name,
        e.ManagerID,
        e.DepartmentID,
        e.RoleID
    FROM 
        Employees e
    INNER JOIN 
        Subordinates s ON e.ManagerID = s.EmployeeID
)

SELECT 
    s.EmployeeID,
    s.Name,
    s.ManagerID,
    d.DepartmentName,
    r.RoleName,
    COALESCE(string_agg(DISTINCT p.ProjectName, ', '), NULL) AS ProjectNames,
    COALESCE(string_agg(DISTINCT t.TaskName, ', '), NULL) AS TaskNames,
    COUNT(DISTINCT t.TaskID) AS TotalTasks,
    COUNT(DISTINCT e.EmployeeID) AS TotalSubordinates
FROM 
    Subordinates s
LEFT JOIN 
    Departments d ON s.DepartmentID = d.DepartmentID
LEFT JOIN 
    Roles r ON s.RoleID = r.RoleID
LEFT JOIN 
    Projects p ON p.DepartmentID = s.DepartmentID
LEFT JOIN 
    Tasks t ON t.AssignedTo = s.EmployeeID
LEFT JOIN 
    Employees e ON e.ManagerID = s.EmployeeID
GROUP BY 
    s.EmployeeID, s.Name, s.ManagerID, d.DepartmentName, r.RoleName
ORDER BY 
    s.EmployeeID;
