import * as bcrypt from 'bcryptjs';
import HttpException from "~/models/http-exception.model";
import {definePrivateEventHandler} from "~/auth-event-handler";

export default definePrivateEventHandler(async (event, {auth}) => {
    const {user} = await readBody(event);

    const {email, username, password, image, bio} = user;
    let hashedPassword;

    if (password) {
        hashedPassword = await bcrypt.hash(password, 10);
    }

    const errors: any = {};
    if (email !== undefined && !email) errors.email = ["can't be blank"];
    if (username !== undefined && !username) errors.username = ["can't be blank"];
    if (Object.keys(errors).length) {
        throw new HttpException(422, {errors});
    }

    const normalize = (val: any) => (val === '' ? null : val);

    const data: any = {};
    if (email !== undefined) data.email = email;
    if (username !== undefined) data.username = username;
    if (password) data.password = hashedPassword;
    if (image !== undefined) data.image = normalize(image);
    if (bio !== undefined) data.bio = normalize(bio);

    const updatedUser = await usePrisma().user.update({
        where: {
            id: auth.id,
        },
        data,
        select: {
            id: true,
            email: true,
            username: true,
            bio: true,
            image: true,
        },
    });

    return {
        user: {
            ...updatedUser,
            token: useGenerateToken(updatedUser.id),
        }
    };
});
