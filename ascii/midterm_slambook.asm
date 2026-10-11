section .data
    clear_screen db 27, '[2J', 27, '[H'
    border db '+------------------------------------------------------------------------------+', 0

    title db 'MY FIRST SLAMBOOK', 0
    about db 'ABOUT ME', 0
    name_label db 'Name:', 0
    email_label db 'Email:', 0
    blog_label db 'Blog/Website:', 0
    first_label db 'My first big achievement:', 0
    book_label db 'First novel I ever took:', 0
    happy_label db 'First time I felt completely happy:', 0
    favorites db 'MY FAVORITES', 0
    colors_label db 'Colors:', 0
    perfume_label db 'Perfume:', 0
    music_label db 'Music:', 0
    singers_label db 'Singers:', 0
    song_label db 'Song:', 0
    food_label db 'Food:', 0
    weekend_label db 'Weekend activity:', 0
    hobbies_label db 'HOBBIES', 0
    tv_label db 'TV Show:', 0
    movie_label db 'Movie:', 0
    book2_label db 'Book:', 0
    celeb_label db 'Celeb:', 0
    role_label db 'Role model:', 0
    ambition_label db 'AMBITION', 0
    motto_label db 'MOTTO', 0

    name_value db 'Earl Christian Gonzales', 0
    email_value db 'etgonzales@fit.edu.ph', 0
    blog_value db 'N/A', 0
    achievement_value db 'Graduate Senior High School', 0
    novel_value db 'Harry Potter: Goblet of Fire', 0
    happy_value db 'N/A', 0
    colors_value db 'Gray and Black', 0
    perfume_value db 'YSL Y Eau de Toilette', 0
    music_value db 'OPM Hiphop and Alt Rock', 0
    singers_value db 'Weezer, Feng, Isaiah Rashad', 0
    song_value db 'Wasted Youth by Feng', 0
    food_value db 'Sizzling Sisig and also Fries', 0
    weekend_value db 'Playing games and editing videos', 0
    tv_value db 'The Mentalist', 0
    movie_value db 'A Silent Voice', 0
    book_value db 'The Da Vinci Code', 0
    celeb_value db 'N/A', 0
    role_value db 'My family', 0
    ambition_value db 'N/A', 0
    motto_value db '"DO YOUR BEST, AND GOD WILL DO THE REST."', 0

    screen db 27, '[1;1H', 27, '[36m', '+------------------------------------------------------------------------------+', 0
           db 27, '[2;1H', '+------------------------------------------------------------------------------+', 0
           db 27, '[4;4H', 'MY FIRST SLAMBOOK', 0
           db 27, '[5;4H', 'A personal profile page in Assembly Language', 0

           db 27, '[7;4H', 'ABOUT ME', 0
           db 27, '[9;4H', 'Name:', 0
           db 27, '[9;32H', 'Earl Christian T. Gonzales', 0
           db 27, '[10;4H', 'Email:', 0
           db 27, '[10;32H', 'etgonzales@fit.edu.ph', 0
           db 27, '[11;4H', 'FIRST BIG ACHIEVEMENT:', 0
           db 27, '[11;32H', 'Graduate Senior High School', 0
           db 27, '[12;4H', 'FIRST BOOK I EVER READ:', 0
           db 27, '[12;32H', 'Harry Potter: Goblet of Fire', 0

           db 27, '[17;4H', 'MY FAVES', 0
           db 27, '[19;4H', 'COLOR/S:', 0
           db 27, '[19;32H', 'Gray and Black', 0
           db 27, '[20;4H', 'PERFUME:', 0
           db 27, '[20;32H', 'YSL Y Eau de Toilette', 0
           db 27, '[21;4H', 'MUSIC:', 0
           db 27, '[21;32H', 'OPM Hiphop and Alt Rock', 0
           db 27, '[22;4H', 'SINGER/S:', 0
           db 27, '[22;32H', 'Weezer, Feng, Isaiah Rashad', 0
           db 27, '[23;4H', 'SONG:', 0
           db 27, '[23;32H', 'Wasted Youth by Feng', 0
           db 27, '[24;4H', 'FOOD:', 0
           db 27, '[24;32H', 'Sizzling Sisig and also Fries', 0
           db 27, '[25;4H', 'WEEKEND ACTIVITY:', 0
           db 27, '[25;32H', 'Playing games and editing videos', 0

           db 27, '[28;4H', 'HOBBIES', 0
           db 27, '[30;4H', 'TV SHOW:', 0
           db 27, '[30;32H', 'The Mentalist', 0
           db 27, '[31;4H', 'MOVIE:', 0
           db 27, '[31;32H', 'A Silent Voice', 0
           db 27, '[32;4H', 'BOOK:', 0
           db 27, '[32;32H', 'The Da Vinci Code', 0
           db 27, '[33;4H', 'CELEBS:', 0
           db 27, '[33;32H', 'N/A', 0
           db 27, '[34;4H', 'ROLE MODEL:', 0
           db 27, '[34;32H', 'My Family', 0

           db 27, '[37;4H', 'MOTTO:', 0
           db 27, '[37;32H', '"DO YOUR BEST, AND GOD WILL DO THE REST."', 0
           db 27, '[39;1H', '+------------------------------------------------------------------------------+', 0
           db 27, '[40;1H', '+------------------------------------------------------------------------------+', 0
           db 27, '[42;1H', 27, '[0m'
    screen_end:

section .text
    global _start

_start:
    mov eax, 4
    mov ebx, 1
    mov ecx, clear_screen
    mov edx, 7
    int 0x80

    mov eax, 4
    mov ebx, 1
    mov ecx, screen
    mov edx, screen_end - screen
    int 0x80

    mov eax, 1
    xor ebx, ebx
    int 0x80