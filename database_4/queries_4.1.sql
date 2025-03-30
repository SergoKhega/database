WITH RECURSIVE EmployeeHierarchy AS (
 
    SELECT 
        e.EmployeeID,
        e.Name,
        e.ManagerID,
        e.DepartmentID,
        e.RoleID
    FROM 
        Employees e
    WHERE 
        e.EmployeeID = 1

    UNION ALL

    SELECT 
        e.EmployeeID,
        e.Name,
        e.ManagerID,
        e.DepartmentID,
        e.RoleID
    FROM 
        Employees e
    INNER JOIN EmployeeHierarchy eh ON e.ManagerID = eh.EmployeeID
)

SELECT 
    eh.EmployeeID,
    eh.Name,
    eh.ManagerID,
    d.DepartmentName,
    r.RoleName,
    STRING_AGG(DISTINCT p.ProjectName, ', ') AS Projects,
    STRING_AGG(DISTINCT t.TaskName, ', ') AS Tasks
FROM 
    EmployeeHierarchy eh
LEFT JOIN 
    Departments d ON eh.DepartmentID = d.DepartmentID
LEFT JOIN 
    Roles r ON eh.RoleID = r.RoleID
LEFT JOIN 
    Projects p ON p.DepartmentID = eh.DepartmentID
LEFT JOIN 
    Tasks t ON t.AssignedTo = eh.EmployeeID
GROUP BY 
    eh.EmployeeID, eh.Name, eh.ManagerID, d.DepartmentName, r.RoleName
ORDER BY 
    eh.Name;
