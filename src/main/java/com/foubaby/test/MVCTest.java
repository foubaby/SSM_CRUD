package com.foubaby.test;

import com.foubaby.domain.Employee;
import com.github.pagehelper.PageInfo;
import org.junit.Before;
import org.junit.Test;
import org.junit.runner.RunWith;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.mock.web.MockHttpServletRequest;
import org.springframework.test.context.ContextConfiguration;
import org.springframework.test.context.junit4.SpringJUnit4ClassRunner;
import org.springframework.test.context.web.WebAppConfiguration;
import org.springframework.test.web.servlet.MockMvc;
import org.springframework.test.web.servlet.MockMvcBuilder;
import org.springframework.test.web.servlet.MvcResult;
import org.springframework.test.web.servlet.request.MockMvcRequestBuilders;
import org.springframework.test.web.servlet.setup.MockMvcBuilders;
import org.springframework.web.context.WebApplicationContext;

import java.util.List;


/**
 *  使用 Spring-Test 单元测试模块提供的测试请求功能，测试CRUD功能
 *  注意；Spring4 测试模块需要 Servlet 3.0.*版本以上的支持
 */
@RunWith(SpringJUnit4ClassRunner.class)
@WebAppConfiguration
@ContextConfiguration(locations = {"classpath:applicationContext.xml", "classpath:dispatcherServlet.xml"})
public class MVCTest {

    // 传入 SpringMVC 的容器 -> 创建控制器对象
    @Autowired
    WebApplicationContext context;

    // 虚拟的MVC请求， 测试获取请求的结果
    MockMvc mockMvc;

    @Before
    public void initMocMvc() {
        mockMvc = MockMvcBuilders.webAppContextSetup(context).build();
    }

    @Test
    public void testPage() throws Exception {
        // 模拟发送请求拿到返回值
        MvcResult result = mockMvc.perform(MockMvcRequestBuilders.get("/emps").param("pn", "1"))
                .andReturn();


        // 请求成功之后，请求域中会有 PageInfo 对象
        MockHttpServletRequest request = result.getRequest();
        PageInfo pageInfo = (PageInfo) request.getAttribute("pageInfo");

        // 验证 pageInfo 中的信息
        System.out.println("当前页码：" + pageInfo.getPageNum());
        System.out.println("总页码：" + pageInfo.getPages());
        System.out.println("总记录数：" + pageInfo.getTotal());
        System.out.print("在页面需要显示的连续的页码数：");
        int[] pageNums = pageInfo.getNavigatepageNums();
        for (int pageNum : pageNums) {
            System.out.print(pageNum + "\t");
        }
        System.out.println("");

        // 获取当前页面的员工数据
        List<Employee> list = pageInfo.getList();
        for (Employee employee : list) {
            System.out.println("ID："+employee.getEmpId()+"==>Name:"
                    + employee.getEmpName() + "==>DeptName:" +
                    employee.getDepartment().getDeptName());

        }

    }
}
