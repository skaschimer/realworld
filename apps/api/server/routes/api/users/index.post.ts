import HttpException from "~/models/http-exception.model";
import {default as bcrypt} from 'bcryptjs';
import {registerUserSchema} from '~/schemas/user.schema';
import {validateBody} from '~/utils/validate';

export default defineEventHandler(async (event) => {
    const {user} = validateBody(registerUserSchema, await readBody(event));

    const {email, username, password, image, bio} = user;

    await checkUserUniqueness(email, username);

    const hashedPassword = await bcrypt.hash(password, 10);

    const createdUser = await usePrisma().user.create({
        data: {
            username,
            email,
            password: hashedPassword,
            ...(image ? {image} : {}),
            ...(bio ? {bio} : {}),
        },
        select: {
            id: true,
            email: true,
            username: true,
            bio: true,
            image: true,
        },
    });

    setResponseStatus(event, 201);
    return {
        user: {
            ...createdUser,
            token: useGenerateToken(createdUser.id),
        }
    };
});

const checkUserUniqueness = async (email: string, username: string) => {
    const existingUserByEmail = await usePrisma().user.findUnique({
        where: {
            email,
        },
        select: {
            id: true,
        },
    });

    const existingUserByUsername = await usePrisma().user.findUnique({
        where: {
            username,
        },
        select: {
            id: true,
        },
    });

    if (existingUserByEmail || existingUserByUsername) {
        throw new HttpException(409, {
            errors: {
                ...(existingUserByEmail ? {email: ['has already been taken']} : {}),
                ...(existingUserByUsername ? {username: ['has already been taken']} : {}),
            },
        });
    }
};
