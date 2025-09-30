package  com.campshare.dao.interfaces;

import com.campshare.model.User;

/**
 * Contrat minimal pour tester la recherche d'un utilisateur.
 */
public interface UserDAO {
    
    /**
     * Trouve un utilisateur par son adresse email.
     * @param email L'email de l'utilisateur à trouver.
     * @return L'objet User correspondant, ou null s'il n'est pas trouvé.
     */
    User findByEmail(String email);

}