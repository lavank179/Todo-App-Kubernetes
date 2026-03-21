from sqlalchemy.orm import DeclarativeBase
from sqlalchemy.ext.asyncio import create_async_engine, async_sessionmaker, AsyncSession
from sqlalchemy.exc import SQLAlchemyError
from utils.config import settings

DB_HOST = settings.DB_HOST
APP_DB_USER = settings.APP_DB_USER
APP_DB_PASSWORD = settings.APP_DB_PASSWORD
APP_DB = settings.APP_DB
# Use the 'postgresql+asyncpg' driver for non-blocking I/O
DATABASE_URL = f"postgresql+asyncpg://{APP_DB_USER}:{APP_DB_PASSWORD}@{DB_HOST}:5432/{APP_DB}"

# 1. Create the Async Engine
engine = create_async_engine(
    DATABASE_URL,
    echo=False,          # Set to False in production to stop SQL logging
    future=True,        # Use SQLAlchemy 2.0 style
    pool_size=5,        # Adjust based on your traffic
    max_overflow=10
)

# 2. Create a Session Factory
AsyncSessionLocal = async_sessionmaker(
    bind=engine,
    class_=AsyncSession,
    expire_on_commit=False,
    autocommit=False,
    autoflush=False,
)

# 3. Base class for your Mapped Models
class Base(DeclarativeBase):
    pass

# 4. Dependency to inject into FastAPI routes
async def get_db():
    async with AsyncSessionLocal() as session:
        try:
            yield session
        except SQLAlchemyError as e:
            await session.rollback()
            raise e   # let FastAPI handle it
        finally:
            await session.close()