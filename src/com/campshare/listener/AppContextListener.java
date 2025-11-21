
package com.campshare.listener;

import com.campshare.task.CheckReservationsTask;

import javax.servlet.ServletContextEvent;
import javax.servlet.ServletContextListener;
import javax.servlet.annotation.WebListener;
import java.util.concurrent.Executors;
import java.util.concurrent.ScheduledExecutorService;
import java.util.concurrent.TimeUnit;

@WebListener
public class AppContextListener implements ServletContextListener {

  private ScheduledExecutorService scheduler;

  @Override
  public void contextInitialized(ServletContextEvent sce) {
    System.out.println("==================================================");
    System.out.println("  Application CampShare DEMARREE");
    System.out.println("  Initialisation du planificateur de notifications...");
    System.out.println("==================================================");

    scheduler = Executors.newSingleThreadScheduledExecutor();
    scheduler.scheduleAtFixedRate(new CheckReservationsTask(), 1, 1440, TimeUnit.MINUTES);
    System.out.println("Planificateur de notifications de reservation demarre. Prochaine execution dans ~1 min.");
  }

  @Override
  public void contextDestroyed(ServletContextEvent sce) {
    if (scheduler != null) {
      scheduler.shutdown();
      try {
        if (!scheduler.awaitTermination(60, TimeUnit.SECONDS)) {
          scheduler.shutdownNow();
        }
      } catch (InterruptedException ex) {
        scheduler.shutdownNow();
        Thread.currentThread().interrupt();
      }
    }
    System.out.println("==================================================");
    System.out.println("  Application CampShare ARRETEE");
    System.out.println("  Planificateur de notifications arrete.");
    System.out.println("==================================================");
  }
}