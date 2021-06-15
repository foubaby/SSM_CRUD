package com.foubaby.test;

import com.foubaby.dao.DepartmentMapper;
import com.foubaby.dao.EmployeeMapper;
import com.foubaby.domain.Department;
import com.foubaby.domain.Employee;
import org.apache.ibatis.session.SqlSession;
import org.junit.Test;
import org.junit.runner.RunWith;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.test.context.ContextConfiguration;
import org.springframework.test.context.junit4.SpringJUnit4ClassRunner;

import java.util.UUID;

/**
 *  测试DAO层的工作，即使用逆向工程创建的mapper文件
 *  因为 Spring 和 MyBatis 整合在了一起，而且在 Spring 容器里面又配置了
 *  自动扫描 Mapper 的组件，所有能从 Spring 容器里面拿到 Mapper
 *
 *  因此 Spring 的项目就可以使用 Spring 的单元测试，可以自动注入我们需要的
 *  组件 / 对象
 *
 *  使用：
 *      1.  导入 Spring-Test 单元测试模块
 *      2.  使用@ContextConfiguration 注解指定Spring配置文件的位置，
 *          自动棒我们创建好IOC的容器
 *      3.  接下来使用哪些组件直接 @AutoWired 组件即可
 *
 */
@RunWith(SpringJUnit4ClassRunner.class)// 指定运行Test的时候运行的是那个单元模块
@ContextConfiguration(locations = {"classpath:applicationContext.xml"})
public class MapperTest {

    @Autowired
    DepartmentMapper departmentMapper;

    @Autowired
    EmployeeMapper employeeMapper;

    @Autowired
    SqlSession sqlSession;

    @Test
    public void testCRUD(){
        System.out.println(employeeMapper);

        //1.插入部门测试
        /*departmentMapper.insertSelective(new Department(null, "开发部"));
        departmentMapper.insertSelective(new Department(null, "测试部"));*/

        //2.生成员工的数据

        //employeeMapper.insertSelective(new Employee(null, "Jack", "M", "Jack@163.com", 1));

        /*EmployeeMapper mapper = sqlSession.getMapper(EmployeeMapper.class);
        String[] gender = {"M", "W"};
        for (int i = 0; i < 1000; i++) {

            String uid = UUID.randomUUID().toString().substring(0, 5) + i;
            mapper.insertSelective(new Employee(null, uid,gender[(int)(Math.random() * 2)], uid + "@gamil.com", (int)(Math.random() * 2 + 1)));
        }
        System.out.println("批量添加数据完成");*/

    }

    @Test
    public void random_num() {
        for (int i = 0; i < 10; i++) {
            System.out.println((int)(Math.random() * 2 + 1));
        }
    }
}
