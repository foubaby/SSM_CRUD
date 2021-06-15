package com.foubaby.service;

import com.foubaby.domain.Employee;

import java.util.List;

public interface EmployeeService {

    List<Employee> getAll();

    int saveEmp(Employee employee);

    boolean checkuser(String empName);

    Employee getEmp(Integer id);

    void updateEmp(Employee employee);

    void deleteEmpById(Integer id);

    void deleteAll(List<Integer> list);
}
