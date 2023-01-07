import java.io.IOException;
import com.espertech.esper.common.client.configuration.Configuration;
import com.espertech.esper.runtime.client.EPRuntime;
import com.espertech.esper.runtime.client.EPRuntimeProvider;
import com.espertech.esper.common.client.EPCompiled;
import com.espertech.esper.common.client.configuration.Configuration;
import com.espertech.esper.compiler.client.CompilerArguments;
import com.espertech.esper.compiler.client.EPCompileException;
import com.espertech.esper.compiler.client.EPCompilerProvider;
import com.espertech.esper.runtime.client.*;

public class Main {
    public static void main(String[] args) throws IOException {
        Configuration configuration = new Configuration();
        configuration.getCommon().addEventType(KursAkcji.class);
        EPRuntime epRuntime = EPRuntimeProvider.getDefaultRuntime(configuration);

////                   5
//        EPDeployment deployment = compileAndDeploy(epRuntime,
//                "select istream data, kursZamkniecia, spolka,  max(kursZamkniecia)-kursZamkniecia as roznica \n" +
//                    "from KursAkcji.win:ext_timed_batch(data.getTime(), 1 day)");

////                   6
//        EPDeployment deployment = compileAndDeploy(epRuntime,
//                "select istream data, kursZamkniecia, spolka,  max(kursZamkniecia)-kursZamkniecia as roznica \n" +
//                        "from KursAkcji.win:ext_timed_batch(data.getTime(), 1 day)" +
//                        "where spolka in ('IBM', 'Honda', 'Microsoft') ");
////                   7
        // a
//        EPDeployment deployment = compileAndDeploy(epRuntime,
//                "select istream data, kursZamkniecia, spolka,  kursOtwarcia " +
//                        "from KursAkcji.win:length(1)" +
//                        "where kursOtwarcia < kursZamkniecia");
        // b
//        EPDeployment deployment = compileAndDeploy(epRuntime,
//                "select istream data, kursZamkniecia, spolka,  kursOtwarcia " +
//                        "from KursAkcji(KursAkcji.czyWzrost(kursOtwarcia,kursZamkniecia)).win:length(1)");

////                   8
//        EPDeployment deployment = compileAndDeploy(epRuntime,
//                "select istream data, kursZamkniecia, spolka, max(kursZamkniecia)-kursZamkniecia as roznica " +
//                        "from KursAkcji(spolka in ('CocaCola', 'PepsiCo')).win:ext_timed(data.getTime(), 7 days) ");

////                   9
//        EPDeployment deployment = compileAndDeploy(epRuntime,
//                "select istream data, kursZamkniecia, spolka, max(kursZamkniecia)-kursZamkniecia as roznica " +
//                        "from KursAkcji(spolka in ('CocaCola', 'PepsiCo')).win:ext_timed(data.getTime(), 1 day) " +
//                        "having max(kursZamkniecia)=kursZamkniecia "
//                        );

////                   10
//        EPDeployment deployment = compileAndDeploy(epRuntime,
//                "select istream max(kursZamkniecia) as maksimum " +
//                        "from KursAkcji.win:ext_timed_batch(data.getTime(), 7 days) " );

////                   11
//        EPDeployment deployment = compileAndDeploy(epRuntime,
//                "select istream c.kursZamkniecia kursCoc, p.data, p.kursZamkniecia as kursPep " +
//                        "from KursAkcji(spolka in ('PepsiCo')).win:ext_timed(data.getTime(), 1 day) p join" +
//                        "  KursAkcji(spolka in ('CocaCola')).win:ext_timed(data.getTime(), 1 day)  c " +
//                        "  on c.data = p.data " +
//                        "where c.kursZamkniecia< p.kursZamkniecia" );

////                   12
//        EPDeployment deployment = compileAndDeploy(epRuntime,
//                "select istream k.data, k.kursZamkniecia as kursBiezacy, k.spolka, k.kursZamkniecia-b.kursZamkniecia as roznica " +
//                        "from KursAkcji(spolka in ('CocaCola', 'PepsiCo')).win:ext_timed(data.getTime(), 1 day) k join " +
//                        " KursAkcji(spolka in ('CocaCola', 'PepsiCo')).std:firstunique(spolka) b " +
//                        "on k.spolka=b.spolka " );

////                   13
//        EPDeployment deployment = compileAndDeploy(epRuntime,
//                "select istream k.data, k.kursZamkniecia as kursBiezacy, k.spolka, k.kursZamkniecia-b.kursZamkniecia as roznica " +
//                        "from KursAkcji.win:ext_timed(data.getTime(), 1 day) k join " +
//                        " KursAkcji.std:firstunique(spolka) b " +
//                        "on k.spolka=b.spolka " +
//                        "where k.kursZamkniecia > b.kursZamkniecia" );

////                   14
//        EPDeployment deployment = compileAndDeploy(epRuntime,
//                "select istream k.data, a.data, k.spolka, a.kursZamkniecia, k.kursZamkniecia " +
//                       "from KursAkcji.win:ext_timed(data.getTime(), 7 days) k join " +
//                        " KursAkcji.win:ext_timed(data.getTime(), 7 days) a " +
//                        "on k.spolka=a.spolka " +
//                        "where a.kursZamkniecia - k.kursZamkniecia > 3" );

////                   15
//        EPDeployment deployment = compileAndDeploy(epRuntime,
//        "select istream data, spolka, obrot " +
//            "from KursAkcji(market = 'NYSE').win:ext_timed_batch(data.getTime(), 7 days) " +
//            "order by obrot desc limit 3");

////                   16
        EPDeployment deployment = compileAndDeploy(epRuntime,
        "select istream data, spolka, obrot " +
            "from KursAkcji(market = 'NYSE').win:ext_timed_batch(data.getTime(), 7 days) " +
            "order by obrot desc limit 2, 1");

        ProstyListener prostyListener = new ProstyListener();
        for (EPStatement statement : deployment.getStatements()) {
            statement.addListener(prostyListener);
        }

        InputStream inputStream = new InputStream();
        inputStream.generuj(epRuntime.getEventService());

    }
    public static EPDeployment compileAndDeploy(EPRuntime epRuntime, String epl) {
        EPDeploymentService deploymentService = epRuntime.getDeploymentService();
        CompilerArguments args = new CompilerArguments(epRuntime.getConfigurationDeepCopy());
        EPDeployment deployment;
        try {
            EPCompiled epCompiled = EPCompilerProvider.getCompiler().compile(epl, args);
            deployment = deploymentService.deploy(epCompiled);
        } catch (EPCompileException e) {
            throw new RuntimeException(e);
        } catch (EPDeployException e) {
            throw new RuntimeException(e);
        }
        return deployment;
    }
}
