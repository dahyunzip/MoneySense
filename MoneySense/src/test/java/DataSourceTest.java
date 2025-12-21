import java.sql.Connection;

import javax.sql.DataSource;

import org.junit.Test;
import org.junit.runner.RunWith;
import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.test.context.ContextConfiguration;
import org.springframework.test.context.junit4.SpringJUnit4ClassRunner;

@RunWith(SpringJUnit4ClassRunner.class)
@ContextConfiguration("file:src/main/webapp/WEB-INF/spring/root-context.xml")
public class DataSourceTest {
	private static final Logger logger = LoggerFactory.getLogger(DataSourceTest.class);
	
	@Autowired
	private DataSource dataSource;
	
	@Test
	public void textConnection() {
		try(Connection conn = dataSource.getConnection()){
			logger.info("  =============================  ");
			logger.info(" DB 연결 성공 ! ");
			logger.info("Connection : " + conn);
			logger.info("  =============================  ");
		}catch(Exception e) {
			logger.error(" DB 연결 실패");
			e.printStackTrace();
		}
	}
}
