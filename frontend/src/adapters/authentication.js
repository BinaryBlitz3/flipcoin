import { BACKEND_URL } from "../bkd";
import axios from "../adapters/axios";

const authentication = async () => {
  try {
    const { data } = await axios.get(`${BACKEND_URL}/accounts/authentication`, {
      withCredentials: true,
    });
    return {
      isAuth: data.isAuthenticate,
      user: data.user,
    };
  } catch (error) {
    throw error;
  }
};

export default authentication;
