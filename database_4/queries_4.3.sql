SELECT 
    e.EmployeeID,
    e.Name AS EmployeeName,
    e.ManagerID,
    d.DepartmentName,
    r.RoleName,
    STRING_AGG(DISTINCT p.ProjectName, ', ') AS ProjectNames,
    STRING_AGG(DISTINCT t.TaskName, ', ') AS TaskNames,
    COUNT(sub.EmployeeID) AS SubordinateCount
FROM 
    Employees e
JOIN 
    Departments d ON e.DepartmentID = d.DepartmentID
JOIN 
    Roles r ON e.RoleID = r.RoleID
LEFT JOIN 
    Employees sub ON e.EmployeeID = sub.ManagerID
LEFT JOIN 
    Projects p ON e.EmployeeID = p.DepartmentID
LEFT JOIN 
    Tasks t ON e.EmployeeID = t.AssignedTo
WHERE 
    r.RoleName = 'Менеджер'
GROUP BY 
    e.EmployeeID, e.Name, e.ManagerID, d.DepartmentName, r.RoleName
HAVING 
    COUNT(sub.EmployeeID) > 0;