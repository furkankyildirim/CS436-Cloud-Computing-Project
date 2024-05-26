import { Box } from "@mui/material";

const UserImage = ({ image, size = "60px" }) => {
  // read url from .env file
  const REACT_APP_URL = process.env.REACT_APP_URL;
  return (
    <Box width={size} height={size}>
      <img
        style={{ objectFit: "cover", borderRadius: "50%" }}
        width={size}
        height={size}
        alt="user"
        src={`${image}`}
      />
    </Box>
  );
};

export default UserImage;
